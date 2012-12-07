package com.aljoschability.eclipse.ecodito.ui;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.swt.graphics.Image;

public final class GrecotoImages {
	public static final String WIZBAN_ECORE = "icons/wizban_ecore.png"; //$NON-NLS-1$
	public static final String WIZBAN_GENMODEL = "icons/wizban_genmodel.png"; //$NON-NLS-1$
	public static final String WIZBAN_DIAGRAM = "icons/wizban_diagram.png"; //$NON-NLS-1$

	private new() {
		// hide constructor
	}

	def static final Image get(String key) {
		Activator::get().getImage(key)
	}

	def static final ImageDescriptor getDescriptor(String key) {
		Activator::get().getImageDescriptor(key)
	}
}
