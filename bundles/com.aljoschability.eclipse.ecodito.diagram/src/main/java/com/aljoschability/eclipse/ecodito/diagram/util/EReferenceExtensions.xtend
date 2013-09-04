package com.aljoschability.eclipse.ecodito.diagram.util

import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateConnectionContext
import org.eclipse.graphiti.features.context.IPictogramElementContext

class EReferenceExtensions extends EStructuralFeatureExtensions {
	val static public INSTANCE = new EReferenceExtensions

	private new() {
	}

	def String getIcon() {
		EcorePackage.Literals::EREFERENCE.name
	}

	def EClass getSourceEClass(ICreateConnectionContext context) {
		val bo = context.sourcePictogramElement.bo
		if (bo instanceof EClass) {
			return bo
		}
	}

	def EClass getTargetEClass(ICreateConnectionContext context) {
		val bo = context.targetPictogramElement.bo
		if (bo instanceof EClass) {
			return bo
		}
	}

	def EReference getEReference(IPictogramElementContext context) {
		context.bo.EReference
	}

	def EReference getEReference(IAddContext context) {
		context.newObject.EReference
	}

	def private static EReference getEReference(Object element) {
		if (element instanceof EReference) {
			return element
		}
	}
}
