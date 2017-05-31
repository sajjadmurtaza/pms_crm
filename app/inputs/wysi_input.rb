class WysiInput < SimpleForm::Inputs::TextInput

  def input
    bar = <<-EOD
      <div class="wysi-toolbar">
        <a class="item" data-wysihtml5-command="bold"><i class="bold icon"></i></a>
        <a class="item" data-wysihtml5-command="italic"><i class="italic icon" ></i></a>
        <a class="item" data-wysihtml5-command="underline"><i class="underline icon" ></i></a>
        <a class="item" data-wysihtml5-command="insertOrderedList"><i class="ordered list icon" ></i></a>
        <a class="item" data-wysihtml5-command="insertUnorderedList"><i class="list icon" ></i></a>
        <a class="item" data-wysihtml5-command="createLink"><i class="anchor icon" ></i></a>
        <div data-wysihtml5-dialog="createLink" style="display: none;">
          <label>Link:</label>
          <input class='text' data-wysihtml5-dialog-field="href" value="http://" />
          <a data-wysihtml5-dialog-action="save">Save</a>
          <a data-wysihtml5-dialog-action="cancel">Cancel</a>
        </div>
      </div>
    EOD
    (bar + super).html_safe
  end
end