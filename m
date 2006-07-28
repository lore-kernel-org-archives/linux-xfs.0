Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 07:35:53 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms1.lichtvoll.de [194.150.191.234])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6SEZgDW019917
	for <linux-xfs@oss.sgi.com>; Fri, 28 Jul 2006 07:35:42 -0700
Received: from localhost (dslb-084-056-089-058.pools.arcor-ip.net [84.56.89.58])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 46A47FA68E
	for <linux-xfs@oss.sgi.com>; Fri, 28 Jul 2006 16:35:01 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Problem with xfs_repair
Date: Fri, 28 Jul 2006 16:35:10 +0200
References: <20060728064505.GA14714@charite.de> <200607280656.QAA18277@larry.melbourne.sgi.com> <20060728082950.GA30429@charite.de>
In-Reply-To: <20060728082950.GA30429@charite.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607281635.10559.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Freitag 28 Juli 2006 10:29 schrieb Ralf Hildebrandt:

> >   2. Try the xfs_repair patch I just posted to this list.
>
> This means I'd have to get this running under knoppix (or should I try
> an in place repair)?

Hello Ralf,

its possible to compile xfs_repair under Knoppix V5. I did it once. I do 
not remember the exact steps anymore. I needed uuid lib from ext3-utils 
as documented and I think some additional packages.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
