package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.IPictogramElementContext

class EOperationExtensions extends GraphitiExtensions {
	val static public INSTANCE = new EOperationExtensions

	private new() {
	}

	def String getIcon() {
		EcorePackage.Literals::EOPERATION.name
	}

	def EOperation getEOperation(IPictogramElementContext context) {
		throw new UnsupportedOperationException
	}

	def EOperation getEOperation(IAddContext context) {
		throw new UnsupportedOperationException
	}

	def EClass getEClass(ICreateContext context) {
		val bo = context?.targetContainer?.bo
		if (bo instanceof EClass) {
			return bo
		}
	}
}
