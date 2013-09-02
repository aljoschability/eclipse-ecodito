package com.aljoschability.eclipse.ecodito.diagram

import com.aljoschability.core.ui.runtime.AbstractActivator
import com.aljoschability.core.ui.runtime.IActivator

final class Activator extends AbstractActivator {
	static IActivator INSTANCE

	def static IActivator get() {
		Activator::INSTANCE
	}

	override void initialize() {
		Activator::INSTANCE = this
	}

	override void dispose() {
		Activator::INSTANCE = null
	}
}
