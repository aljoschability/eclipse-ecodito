package com.aljoschability.eclipse.ecodito.diagram.util

import com.aljoschability.eclipse.core.graphiti.util.GraphitiExtensions
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.IPictogramElementContext

class EEnumLiteralExtensions extends GraphitiExtensions {
	val static public INSTANCE = new EEnumLiteralExtensions

	private new() {
	}

	def String getIcon() {
		EcorePackage.Literals::EENUM_LITERAL.name
	}

	def EEnum getEEnum(ICreateContext context) {
		val bo = context?.targetContainer?.bo
		if (bo instanceof EEnum) {
			return bo
		}
	}

	def EEnumLiteral getEEnumLiteral(IPictogramElementContext context) {
		context.bo.EEnumLiteral
	}

	def EEnumLiteral getEEnumLiteral(IAddContext context) {
		context.newObject.EEnumLiteral
	}

	def private static EEnumLiteral getEEnumLiteral(Object element) {
		if (element instanceof EEnumLiteral) {
			return element
		}
	}
}
