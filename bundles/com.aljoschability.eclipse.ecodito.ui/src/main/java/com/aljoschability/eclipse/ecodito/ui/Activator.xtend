package com.aljoschability.eclipse.ecodito.ui;

import com.aljoschability.core.ui.runtime.AbstractActivator;
import com.aljoschability.core.ui.runtime.IActivator;

final class Activator extends AbstractActivator {
	static IActivator INSTANCE

	def static IActivator get() {
		Activator::INSTANCE
	}

	override void initialize() {
		Activator::INSTANCE = this

		// add images
		addImage(GrecotoImages.WIZBAN_ECORE)
		addImage(GrecotoImages.WIZBAN_GENMODEL)
		addImage(GrecotoImages.WIZBAN_DIAGRAM)
	}

	override void dispose() {
		Activator::INSTANCE = null
	}
}
