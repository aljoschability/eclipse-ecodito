package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.pattern.config.IPatternConfiguration

class EEnumPattern extends CorePattern {
	new(IPatternConfiguration patternConfiguration) {
		super();
	}

	override canCreate(ICreateContext context) {
		val pe = context.getTargetContainer();
		return getBO(pe) instanceof EPackage;
	}

	override protected isBO(Object bo) {
		return bo instanceof EDataType;
	}

	override protected getEClass() {
		return EcorePackage.Literals.EENUM;
	}
}
