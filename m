Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 65B607F47
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 19:37:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37C148F804B
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 17:36:58 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	y8bGuMJvaCqwPQRZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 17:36:51 -0700 (PDT)
Received: by wicgb1 with SMTP id gb1so96318409wic.1
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 17:36:49 -0700 (PDT)
Received: from [192.168.0.234] (84-73-90-113.dclient.hispeed.ch.
	[84.73.90.113]) by smtp.googlemail.com with ESMTPSA id
	p3sm7039950wib.16.2015.09.16.17.36.48 for <xfs@oss.sgi.com>
	(version=TLSv1/SSLv3 cipher=OTHER);
	Wed, 16 Sep 2015 17:36:49 -0700 (PDT)
From: Viktor Trojanovic <viktor@troja.ch>
Subject: XFS FAQ - out of date?
Message-ID: <55FA0B1D.8000905@troja.ch>
Date: Thu, 17 Sep 2015 02:36:45 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I just tried to do a fresh install of Arch Linux using XFS for my root 
system. According to the xfs.org FAQ, this is supported. But it didn't work.

I later found (very few) sources that confirmed that Grub is not 
compatible with the current XFS level 5, that SuSE created a patch for 
the problem but it wasn't adopted upstream. If this is true, consider 
updating the FAQ. If it is not true, I would very much appreciate some 
hints how to do it properly.

Thank you.

Best regards,
Viktor

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
