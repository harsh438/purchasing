require 'barby'
require 'barby/barcode/code_39'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

class PackingList::Pdf < Prawn::Document
  def initialize(page_layout, data)
    super(page_layout)
    @grn = data
    @layout = page_layout
  end

  def new_page
    start_new_page(@layout)
  end

  def grn_paper
    font 'Helvetica', size: 35, style: :bold
    text "GRN: <u>#{@grn.id}</u>", inline_format: true, size: 85
    move_down 15
    text "BRAND(s):  #{@grn.vendor_name}"
    move_down 15
    text "DELIVERY DATE: #{@grn.delivery_date}"
    move_down 15
    text "NO OF CARTONS: #{@grn.cartons}"
    move_down 15
    text "NO OF PALLETS: #{@grn.pallets}"
  end

  def check_sheet(purchase_orders)
    font 'Helvetica', size: 14
    grn_info
    po_table(purchase_orders)
    sign_off_table
  end

  def grn_info
    grn_info_grid
    grn_info_text
    move_down 45
  end

  def grn_info_grid
    grn_position_data.each do |position_data|
      stroke_rectangle [position_data[:X], position_data[:Y]],
                       position_data[:width], position_data[:height]
    end
  end

  def grn_position_data
    left_x_position = 10
    right_x_position = 298
    [
      { X: left_x_position, Y: 810, width: 570, height: 20 },
      { X: left_x_position, Y: 788, width: 285, height: 33 },
      { X: left_x_position, Y: 752, width: 285, height: 33 },
      { X: left_x_position, Y: 717, width: 285, height: 15 },
      { X: left_x_position, Y: 700, width: 285, height: 15 },
      { X: left_x_position, Y: 683, width: 285, height: 33 },
      { X: left_x_position, Y: 648, width: 570, height: 30 },
      { X: left_x_position, Y: 616, width: 570, height: 15 },
      { X: right_x_position, Y: 788, width: 282, height: 15 },
      { X: right_x_position, Y: 770, width: 282, height: 15 },
      { X: right_x_position, Y: 752, width: 282, height: 15 },
      { X: right_x_position, Y: 734, width: 282, height: 15 },
      { X: right_x_position, Y: 717, width: 282, height: 15 },
      { X: right_x_position, Y: 700, width: 282, height: 15 },
      { X: right_x_position, Y: 683, width: 282, height: 15 }
    ]
  end

  def grn_info_text
    grn_barcode
    grn_info_text_data.each do |text_data|
      font_size(8) do
        text_box text_data[:text].to_s,
                 at: text_data[:text_position],
                 inline_format: true
      end
    end
  end

  def grn_barcode
    left_text_box_x_position = 12
    bounding_box([left_text_box_x_position + 25, 660], width: 60) do
      barcode = Barby::Code128.new(@grn.id.to_s)
      barcode.annotate_pdf(self, height: 22, align: :center, length: 200)
      text @grn.id.to_s, align: :center, size: 10
    end
  end

  def grn_info_text_data
    left = 12
    right = 299
    [
      { text: "<b>GOODS IN CHECK SHEET</b>", text_position: [10, 806] },
      { text: "Delivery condition<br><u>ANY ISSUES MUST BE PHOTOGRAPHED</u>",
        text_position: [left, 787] },
      { text: "Cartons in good condition: Y / N",
        text_position: [left, 750] },
      { text: "GRN or PO marked cartons: Y / N   No of cartons: ...",
        text_position: [left, 715] },
      { text: "Packing list received: Y / N", text_position: [left, 698] },
      { text: "GRN:", text_position: [left, 680] },
      { text: "Date Delivered:", text_position: [right, 787] },
      { text: "Brand: <b>#{@grn.vendor_name}</b>",
        text_position: [right, 768] },
      { text: "Quantity of boxes expected:", text_position: [right, 750] },
      { text: "Quantity of boxes delivered:", text_position: [right, 750] },
      { text: "Quantity of boxes delivered:", text_position: [right, 732] },
      { text: "Location:", text_position: [right, 715] },
      { text: "Checked by:", text_position: [right, 698] },
      { text: "Intake by (Signed by):", text_position: [right, 681] },
      { text: "Delivery Intake Issues comments:", text_position: [left, 646] },
      { text: "Time to resolve Delivery Intake Issues: ",
        text_position: [left, 614] }
    ]
  end

  def po_header
    left_x_position = 10
    height = 40
    y_postion = cursor
    text_box_y_postion = y_postion - 15
    data = po_header_data

    data.each do |item|
      font_size(8) do
        stroke_rectangle [left_x_position, y_postion],
                         item[:rectangle_type], height
        text_box item[:text].to_s, at: [left_x_position, text_box_y_postion],
                                  style: :bold, align: :center,
                                  width: item[:rectangle_type],
                                  height: height, inline_format: true
        left_x_position += item[:rectangle_type]
      end
    end
    y_postion -= (height + 2)
  end

  def po_header_data
    big_rectangle = 165
    small_rectangle = 80
    [
      { text: '<u>PO</u>', rectangle_type: big_rectangle },
      { text: "<u>Expct'd<br>Y or N?</u>", rectangle_type: small_rectangle },
      { text: '<u>Delivered<br>Y or N?</u>', rectangle_type: small_rectangle },
      { text: '<u><u>Req Prep<br>Y or N?</u>',
        rectangle_type: small_rectangle },
      { text: '<u>Issues</u>', rectangle_type: big_rectangle }
    ]
  end

  def po_table(purchase_orders)
    left_x_position = 10
    big_rectangle = 165
    small_rectangle = 80
    height = 40
    y_postion = po_header

    purchase_orders.each do |purchase_order|
      stroke_rectangle [left_x_position, y_postion], big_rectangle, height
      po_barcode(y_postion, purchase_order)
      left_x_position += big_rectangle

      3.times do
        stroke_rectangle [left_x_position, y_postion], small_rectangle, height
        left_x_position += small_rectangle
      end

      stroke_rectangle [left_x_position, y_postion], big_rectangle, height
      y_postion -= (height + 2)

      if y_postion < 50
        new_page
        y_postion = 810
      end
      left_x_position = 10
    end
  end

  def po_barcode(y_postion, purchase_order)
    bounding_box([40, y_postion - 25], width: 60) do
      barcode = Barby::Code128.new(purchase_order)
      barcode.annotate_pdf(self, height: 22, align: :center, length: 200)
      text purchase_order, align: :center, size:10
    end
  end

  def sign_off_data
    ['<b><u>This section MUST be filled out when receiving delivery.
      Each issue MUST be photographed:</u></b>',
     'Packed correctly: Y / N',
     'Barcodes correct: Y / N',
     'Items in poly bag or box: Y / N',
     "<b><u>If any of the above have been marked 'NO' then you MUST fill
     out a Delivery Issue Detail Form for each issue</b></u>",
     'QUARANTINE',
     'All items ok: Y / N',
     'Pids:',
     'SKU(s):']
  end

  def sign_off_header(y_postion)
    left_x_position = 10
    small_rectangle = 140
    height = 15
    text_box_y_postion = y_postion - 5

    data = ['Prepared by:', 'Start time:', 'End time:', 'Time taken:']
    data.each do |title|
      font_size(8) do
        stroke_rectangle [left_x_position, y_postion], small_rectangle, height
        text_box title.to_s, at: [left_x_position, text_box_y_postion],
                             style: :bold, align: :center,
                             width: small_rectangle,
                             height: height, inline_format: true
        left_x_position += (small_rectangle + 3)
      end
    end
  end

  def sign_off_questions(y_postion)
    left_x_position = 10
    height = 15
    y_postion -= (height + 3)
    text_box_y_postion = y_postion - 8

    full_rectangle = 570

    sign_off_data.each do |title|
      font_size(8) do
        stroke_rectangle [left_x_position, y_postion], full_rectangle, height
        text_box title.to_s, at: [left_x_position, text_box_y_postion],
                             align: :left, width: full_rectangle,
                             height: height, inline_format: true
        y_postion -= (height + 3)
        text_box_y_postion -= (height + 3)
      end
    end
    return text_box_y_postion, y_postion
  end

  def received_by_table(y_postion, text_box_y_postion)
    data = ['Received by', 'Start date', 'Start Time',
            'End Time', 'End Date', 'Time taken', 'Any errors?']

    left_x_position = 10
    small_rectangle = 77
    blank_y = 0
    height = 15

    data.each do |title|
      font_size(8) do
        stroke_rectangle [left_x_position, y_postion], small_rectangle, height
        text_box title.to_s, at: [left_x_position, text_box_y_postion],
                             style: :bold, align: :center,
                             width: small_rectangle, height: height,
                             inline_format: true

        blank_y = y_postion - (height + 3)
        4.times do
          stroke_rectangle [left_x_position, blank_y], small_rectangle, height
          blank_y -= (height + 3)
        end
        left_x_position += (small_rectangle + 5)
      end
    end

    left_x_position
  end

  def comment_table(y_postion)
    height = 15
    y_postion -= ((height + 3) * 5)
    text_box_y_postion = y_postion
    small_rectangle = 150
    left_x_position = 10
    padding = 3

    font_size(8) do
      stroke_rectangle [left_x_position, y_postion], small_rectangle, height
      text_box "Over/Under checked by:", at: [left_x_position,
                                              text_box_y_postion],
                                         style: :bold, align: :left,
                                         width: small_rectangle, height: height,
                                         inline_format: true
      y_postion -= (height + padding)
      text_box_y_postion -= (height + padding)
      stroke_rectangle [left_x_position, y_postion], small_rectangle,
                       (height + padding) * 4
      text_box "Comments:", at: [left_x_position, text_box_y_postion],
                            style: :bold, align: :left,
                            width: small_rectangle, height: (height * 4),
                            inline_format: true
    end

    y_postion += (height + padding)
    5.times do
      stroke_rectangle [left_x_position + 154, y_postion], 415, height
      y_postion -= (height + 3.5)
    end
  end

  def new_page_check
    new_page
    y_postion = 810
    y_postion
  end

  def sign_off_table
    y_postion = cursor - 5
    y_postion = new_page_check if cursor < 370
    sign_off_header(y_postion)
    text_box_y_postion, y_postion = sign_off_questions(y_postion)
    received_by_table(y_postion, text_box_y_postion)
    comment_table(y_postion)
  end
end
