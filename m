Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Sep 2007 17:09:31 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8209R4p000640
	for <xfs@oss.sgi.com>; Sat, 1 Sep 2007 17:09:28 -0700
Received: from [89.49.172.106] (helo=[192.168.178.20])
	by mail.g-house.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <lists@nerdbynature.de>)
	id 1IRaAk-0006dw-20
	for xfs@oss.sgi.com; Sat, 01 Sep 2007 23:06:26 +0200
Date: Sat, 1 Sep 2007 23:06:25 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: lockdep annotations?
Message-ID: <alpine.DEB.0.999.0709012300030.6640@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I try to follow -rc kernels and just upgraded to 2.6.23-rc5 and I still 
see: "INFO: possible circular locking dependency detected". Out of 
curiosity: (when) will these warnings be addressed? I mean, suits me for 
enabling CONFIG_LOCKDEP in the first place, but the only warnings I get 
is still xfs :)

FWIW, full log is here: http://nerdbynature.de/bits/2.6.23-rc5/messages_2.6.23-rc5

Thanks,
Christian.
-- 
BOFH excuse #156:

Zombie processes haunting the computer
