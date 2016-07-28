import React from 'react';
import DropZone from 'react-dropzone';

export default class GoodsReceivedNoticesImageUpload extends React.Component {
  handleFileUpload(files) {
    files.forEach((file) => {
      const reader = new FileReader();

      reader.onload = (upload) => {
        const image = {
          image: upload.target.result,
          image_file_name: file.name,
          preview: file.preview,
        };

        this.props.onUpload(image);
      };

      reader.readAsDataURL(file);
    });
  }

  renderFilePreview(file) {
    return (
      <div key={file.preview} style={{ paddingTop: '5px' }}>
        <span className="glyphicon glyphicon-open-file"></span>
        &nbsp;
        <a href={file.image_url} target="_blank">{file.image_file_name}</a>
        <img width="100%" src={file.preview} />
      </div>
    );
  }

  renderFiles() {
    return this.props.files.map(this.renderFilePreview.bind(this));
  }

  render() {
    return (
      <section>
        <DropZone
          multiple
          onDrop={this.handleFileUpload.bind(this)}
          style={{ color: '#999', padding: '30px', border: '2px dashed #999' }}
          inputProps={{ htmlFor: this.props.htmlFor }}
          accept=".jpg,.jpeg,.png,.pdf,.eml">
          <div>
            Image(s) showing the problem. Drag and drop files here, or click to select files to upload.
          </div>
        </DropZone>
        {this.renderFiles()}
      </section>
    );
  }
}

GoodsReceivedNoticesImageUpload.defaultProps = {
  files: [],
};
