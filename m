Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 13:30:11 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6QKU5bm016841
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jul 2007 13:30:07 -0700
Received: from localhost (dslb-084-056-125-167.pools.arcor-ip.net [84.56.125.167])
	by mail.lichtvoll.de (Postfix) with ESMTP id C8B185ADEE
	for <linux-xfs@oss.sgi.com>; Thu, 26 Jul 2007 22:30:59 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfstest 42 does not like to use my $SCRATCH_DEV setting
Date: Thu, 26 Jul 2007 22:30:03 +0200
References: <200707262211.40995.Martin@lichtvoll.de> (sfid-20070726_221933_390593_7B834927)
In-Reply-To: <200707262211.40995.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262230.04176.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Donnerstag 26 Juli 2007 schrieb Martin Steigerwald:
> Hi!
>
> I tried patching xfstests so that test 42 can be used without
> scratchdev with the patch I got from Timothy.

Hi!

Just forget what I wrote... It helps to run make in xfstests before trying 
to run one of those tests. ;)

Test is now running.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
