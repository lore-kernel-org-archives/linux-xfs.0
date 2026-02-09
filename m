Received: from mail.venturex.pl (mail.venturex.pl [141.95.86.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2C6311979
	for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 08:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.95.86.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770626187; cv=none; b=EUL25PLe8+5L+m09whwfeEgvaWoK4ads9AT40GG5mykUJO68grmiVUMUiwZMv4/g80EdFqtOLaKM8uzA4luk6dmQYYeX5HzsfHaHay5KsgNTSX6BlEwbSYRLZ9Vw3L083ELVFPkulHt3OOkE1i9G/asMKFZxts3p5juiwFpOcfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770626187; c=relaxed/simple;
	bh=86VIaF2unP4vg5OpX+J8tHPXWoQ8hu3kSDMcmnIkxvQ=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=EL0R5GKyFJZeHPyZslIkqfdeLhyDW8cpFr1KO6ju7gu5oAmA/dRhlofy+Cge40meAnXk8pvQplq0XhufHpzw69Pop1XhkKxMaJHceIYQwEa1AtK/ygHE+fg8PkCm0cPS2+Ww0Cd0LPKDM5KtlWPMxkSQ9TaR9vdXDZCiaYWrNrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=venturex.pl; spf=pass smtp.mailfrom=venturex.pl; dkim=pass (2048-bit key) header.d=venturex.pl header.i=@venturex.pl header.b=hpSkhkrk; arc=none smtp.client-ip=141.95.86.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=venturex.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=venturex.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=venturex.pl header.i=@venturex.pl header.b="hpSkhkrk"
Received: by mail.venturex.pl (Postfix, from userid 1002)
	id DD4CD21934; Mon,  9 Feb 2026 09:36:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=venturex.pl; s=mail;
	t=1770626185; bh=86VIaF2unP4vg5OpX+J8tHPXWoQ8hu3kSDMcmnIkxvQ=;
	h=Date:From:To:Subject:From;
	b=hpSkhkrkvtdORIfHy/Xdv0Qhs+5+fxGDODZDfpEJHsnfOfcbSyj6CZhfdhzwaxLUZ
	 OJmJZ0APJgvA4+5r2x45N0IM8cuOI9rv2aZFWCptnEqhTowV6DrGyJsSBlXs0iTjds
	 glWMKKgj9dSt8BVf5AQJ0TydhuqqdVpYKKWF3zwFhdTlEb6fMIjjlxQwZ6ddc0YHee
	 O0p4F1aShEFtU6/ejpO1Qnc/hRISW8eXKOdVO8YaAoMe/siCT1fHg0Sd/sgsSGo/7a
	 KDOSh+0ygxlaDvaGDKjN5ASsy8jXwif7yVTxBZH075CdVBR/xiYD6hz3w8Jd1gFbll
	 E7jB0nxdQzAUg==
Received: by mail.venturex.pl for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 08:35:50 GMT
Message-ID: <20260209084501-0.1.ck.2ki2g.0.d39a0u6n71@venturex.pl>
Date: Mon,  9 Feb 2026 08:35:50 GMT
From: =?UTF-8?Q?"Miko=C5=82aj_Rak"?= <mikolaj.rak@venturex.pl>
To: <linux-xfs@vger.kernel.org>
Subject: Fundacja Rodzina a optymalizacja podatkowa 
X-Mailer: mail.venturex.pl
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Szanowni Pa=C5=84stwo,

czy byliby Pa=C5=84stwo zainteresowani rozmow=C4=85 o mo=C5=BCliwych rozw=
i=C4=85zaniach dla swojej firmy i rodziny?

Nowelizacja ustawy o Fundacjach Rodzinnych otwiera przed przedsi=C4=99bio=
rcami zupe=C5=82nie nowe mo=C5=BCliwo=C5=9Bci ochrony maj=C4=85tku i plan=
owania sukcesji. Fundacja Rodzinna pozwala oddzieli=C4=87 aktywa od ryzyk=
 biznesowych, prawnych i podatkowych, a jednocze=C5=9Bnie zachowa=C4=87 k=
ontrol=C4=99 nad swoim maj=C4=85tkiem i zadba=C4=87 o jego trwa=C5=82o=C5=
=9B=C4=87 dla kolejnych pokole=C5=84.

Co istotne, po up=C5=82ywie 10 lat od wniesienia aktyw=C3=B3w do fundacji=
, roszczenia o zachowek przestaj=C4=85 obowi=C4=85zywa=C4=87. Ustawodawca=
 przewidzia=C5=82 r=C3=B3wnie=C5=BC liczne zwolnienia podatkowe obejmuj=C4=
=85ce m.in. dochody z dzia=C5=82alno=C5=9Bci gospodarczej czy wynajem nie=
ruchomo=C5=9Bci.

B=C4=99d=C4=99 wdzi=C4=99czny za informacj=C4=99, czy chcieliby Pa=C5=84s=
two pozna=C4=87 mo=C5=BCliwo=C5=9B=C4=87 stworzenia Fundacji Rodzinnej?


Pozdrawiam
Miko=C5=82aj Rak
