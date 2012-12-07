package com.aljoschability.eclipse.ecodito.ui.patterns;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.graphiti.features.context.ICreateContext;
import org.eclipse.graphiti.mm.pictograms.PictogramElement;
import org.eclipse.graphiti.pattern.config.IPatternConfiguration;

import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern;

public class EEnumPattern extends CorePattern {
	public EEnumPattern(IPatternConfiguration patternConfiguration) {
		super();
	}

	@Override
	public boolean canCreate(ICreateContext context) {
		PictogramElement pe = context.getTargetContainer();
		return getBO(pe) instanceof EPackage;
	}

	@Override
	protected boolean isBO(Object bo) {
		return bo instanceof EDataType;
	}

	@Override
	protected EClass getEClass() {
		return EcorePackage.Literals.EENUM;
	}
}
