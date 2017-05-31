module Core::NotesHelper

  def note_button_for(object)
    links = []
    Core::NoteType.all.each do |note_type|
      links << link_to(note_type.name, new_note_path(notable_id: object.id, notable_type: object.class, note_type_id: note_type.id), remote: true, class: 'item')
    end

    output = <<-ED
      <div class="ui dropdown">
        <div class="text">Add Note</div>
        <i class="dropdown icon"></i>
        <div class="menu">
          #{links.join('')}
        </div>
      </div>
    ED
    output.html_safe
  end

  def filter_button(object)
    links = []
    links << link_to("All Notes", search_notes_path(id: object.id, class: object.class), remote: true, class: 'item')
    Core::NoteType.all.each do |note_type|
      links <<  link_to(note_type.name, search_notes_path(id: object.id, class: object.class,note_type_id: note_type.id), remote: true, class: 'item')
    end

    output = <<-ED
      <div class="ui dropdown">
        <div class="text">Filter notes by note type</div>
        <i class="dropdown icon"></i>
        <div class="menu">
          #{links.join('')}
        </div>
      </div>
    ED
    output.html_safe


  end
end
