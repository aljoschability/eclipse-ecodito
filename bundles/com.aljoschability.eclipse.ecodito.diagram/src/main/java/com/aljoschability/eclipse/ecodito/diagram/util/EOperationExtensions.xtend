package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.ICreateContext

class EOperationExtensions extends GraphitiExtensions {
	val static public INSTANCE = new EOperationExtensions

	private new() {
	}

	def String getIcon() {
		EcorePackage.Literals::EOPERATION.name
	}

	def EClass getEClass(ICreateContext context) {
		val bo = context?.targetContainer?.bo
		if (bo instanceof EClass) {
			return bo
		}
	}
}
