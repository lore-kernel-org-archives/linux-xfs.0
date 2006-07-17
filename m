Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 01:41:55 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6H8fiDW009177
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 01:41:44 -0700
Received: from deepdance.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 0D191FA6B3
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 10:39:07 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS failure
Date: Mon, 17 Jul 2006 10:41:14 +0200
References: <44BAD692.8070402@gmx.de>
In-Reply-To: <44BAD692.8070402@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607171041.14806.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Montag 17 Juli 2006 02:15 schrieb Michel:
> Hello dear developer,
>
> almost every week on checking my fs i get

Hello,

known and already fixed bug, see:

http://bugzilla.kernel.org/show_bug.cgi?id=6757

You need to apply this patch to get it fixed:

http://bugzilla.kernel.org/show_bug.cgi?id=6757#c8

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
