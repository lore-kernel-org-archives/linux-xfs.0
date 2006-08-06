Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 02:46:26 -0700 (PDT)
Received: from mondschein.lichtvoll.de (mondschein.lichtschiff.de [194.150.191.238] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k769kFDW016444
	for <linux-xfs@oss.sgi.com>; Sun, 6 Aug 2006 02:46:15 -0700
Received: from localhost (dslb-084-056-104-201.pools.arcor-ip.net [84.56.104.201])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id B0170FA68A
	for <linux-xfs@oss.sgi.com>; Sun,  6 Aug 2006 11:44:26 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
Date: Sun, 6 Aug 2006 11:45:45 +0200
References: <44CAE247.6020608@sandeen.net> <44CBDFC9.3040202@sandeen.net> <20060731085454.A2280998@wobbly.melbourne.sgi.com>
In-Reply-To: <20060731085454.A2280998@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200608061145.45997.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Montag 31 Juli 2006 00:54 schrieb Nathan Scott:

> Right, its more that we don't have a great track record at the moment
> of not introducing regressions with these cleanups (including myself),
> so I'm becoming more reluctant to do sweeping changes across the whole
> codebase.  Smaller, specific, and obviously-correct things are less
> likely to introduce issues, so if we can achieve basically the same
> thing while churning the code less, I'm all for it.

Hello Nathan,

I fully agree with that - especially as XFS is a file system and 
regressions can easily have desastrous results.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
