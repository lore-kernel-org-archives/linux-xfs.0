Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Jul 2006 02:44:22 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6G9i6DW004897
	for <linux-xfs@oss.sgi.com>; Sun, 16 Jul 2006 02:44:11 -0700
Received: from localhost (dslb-084-056-110-224.pools.arcor-ip.net [84.56.110.224])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 1D807FA4F3
	for <linux-xfs@oss.sgi.com>; Sun, 16 Jul 2006 11:41:44 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: XFS now working stable with write caches - Thank you!
Date: Sun, 16 Jul 2006 11:43:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607161143.38872.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hello,

okay, I am pretty much convinced. See

http://bugzilla.kernel.org/show_bug.cgi?id=6380

Thank you, guys!


Running an automated test case simulating switching the power off while 
writing data for a thousand times might still be a good idea if it has 
not already been done yet and someone can fund it.


Too bad that the XFS fix from 

http://bugzilla.kernel.org/show_bug.cgi?id=6757

still did not make it into a stable kernel release for 2.6.17!

I stronly recommend to apply it if you want to use 2.6.17 and probably 
2.6.16 as well!

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
