package com.aljoschability.eclipse.ecodito.diagram.editor;

import org.eclipse.emf.common.util.URI;
import org.eclipse.graphiti.ui.editor.DiagramEditor;
import org.eclipse.graphiti.ui.editor.IDiagramEditorInput;
import org.eclipse.ui.IEditorInput;

class EcoreDiagramEditor extends DiagramEditor {
	override void refreshTitle() {
		var IEditorInput input = getEditorInput();
		if (input instanceof IDiagramEditorInput) {
			var URI uri = (input as IDiagramEditorInput).getUri();
			setPartName(uri.lastSegment());

			// TODO: this does not function
			setTitleToolTip(uri.trimFragment().toPlatformString(true));
			return;
		}

		super.refreshTitle();
	}
}
