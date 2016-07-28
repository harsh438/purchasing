class AddMissingSeasons < ActiveRecord::Migration
  def change
    dead = Season.create!(SeasonName: 'DEAD', SeasonYear: 'DEAD', SeasonNickname: 'DEAD', sort: -1)

    say_with_time "Updating and creating seasons" do
      [
        { SeasonName: 'SS',   SeasonYear: '2006', SeasonNickname: 'SS06' },
        { SeasonName: 'AW',   SeasonYear: '2006', SeasonNickname: 'AW06' },
        { SeasonName: 'SS',   SeasonYear: '2007', SeasonNickname: 'SS07' },
        { SeasonName: 'AW',   SeasonYear: '2007', SeasonNickname: 'AW07' },
        { SeasonName: 'SS',   SeasonYear: '2008', SeasonNickname: 'SS08' },
        { SeasonName: 'AW',   SeasonYear: '2008', SeasonNickname: 'AW08' },
        { SeasonName: 'SS',   SeasonYear: '2009', SeasonNickname: 'SS09' },
        { SeasonName: 'AW',   SeasonYear: '2009', SeasonNickname: 'AW09' },
        { SeasonName: 'SS',   SeasonYear: '2010', SeasonNickname: 'SS10' },
        { SeasonName: 'AW',   SeasonYear: '2010', SeasonNickname: 'AW10' },
        { SeasonName: 'SS',   SeasonYear: '2011', SeasonNickname: 'SS11' },
        { SeasonName: 'AW',   SeasonYear: '2011', SeasonNickname: 'AW11' },
        { SeasonName: 'SS',   SeasonYear: '2012', SeasonNickname: 'SS12' },
        { SeasonName: 'AW',   SeasonYear: '2012', SeasonNickname: 'AW12' },
        { SeasonName: 'SS',   SeasonYear: '2013', SeasonNickname: 'SS13' },
        { SeasonName: 'AW',   SeasonYear: '2013', SeasonNickname: 'AW13' },
        { SeasonName: 'SS',   SeasonYear: '2014', SeasonNickname: 'SS14' },
        { SeasonName: 'AW',   SeasonYear: '2014', SeasonNickname: 'AW14' },
        { SeasonName: 'SS',   SeasonYear: '2015', SeasonNickname: 'SS15' },
        { SeasonName: 'AW',   SeasonYear: '2015', SeasonNickname: 'AW15' },
        { SeasonName: 'CONT', SeasonYear: 'CONT', SeasonNickname: 'CONT' },
        { SeasonName: 'SS',   SeasonYear: '2016', SeasonNickname: 'SS16' },
        { SeasonName: 'AW',   SeasonYear: '2016', SeasonNickname: 'AW16' },
        { SeasonName: 'SS',   SeasonYear: '2017', SeasonNickname: 'SS17' },
        { SeasonName: 'AW',   SeasonYear: '2017', SeasonNickname: 'AW17' },
      ].each_with_index do |season_hash, i|
        season = Season.find_or_initialize_by(season_hash)
        season.sort = i + 1
        season.save!
      end
    end

    say_with_time "Migrating products without a season to DEAD" do
      products_without_season = Product.find_by_sql <<-SQL.strip_heredoc
        SELECT
          ds_products.*
        FROM
          ds_products
        LEFT JOIN
          seasons ON ds_products.pUDFValue4 = seasons.SeasonNickname
        WHERE
          seasons.SeasonId IS NULL
      SQL

      products_without_season.in_groups_of(1_000, false).each do |group|
        sleep 5
        group.each do |product|
          product.update_column(:pUDFValue4, dead.nickname)
        end
      end
    end

    say_with_time "Migrating SKUs without a season to DEAD" do
      skus_without_season = Sku.find_by_sql <<-SQL.strip_heredoc
        SELECT
          skus.*
        FROM
          skus
        LEFT JOIN
          seasons ON skus.season = seasons.SeasonNickname
        WHERE
          seasons.SeasonId IS NULL
      SQL

      skus_without_season.in_groups_of(1_000, false).each do |group|
        sleep 5
        group.each do |sku|
          sku.update_column(:season, dead.nickname)
        end
      end
    end

  end
end
