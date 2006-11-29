Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 16:11:09 -0800 (PST)
Received: from hapkido.dreamhost.com (hapkido.dreamhost.com [66.33.216.122])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAU0B0aG000689
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 16:11:02 -0800
Received: from randymail-a9.dreamhost.com (sd-green-bigip-207.dreamhost.com [208.97.132.207])
	by hapkido.dreamhost.com (Postfix) with ESMTP id BE4B71845EC
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 15:43:09 -0800 (PST)
Received: from [10.2.255.104] (unknown [208.51.196.2])
	by randymail-a9.dreamhost.com (Postfix) with ESMTP id DF695EEDBE
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 15:43:05 -0800 (PST)
Message-ID: <456E1B08.7090802@delusion.com>
Date: Wed, 29 Nov 2006 15:43:04 -0800
From: Deanan <delusion@delusion.com>
MIME-Version: 1.0
Subject: inode64 workaround
References: <200611290027.AA04740@TNESG9305.tnes.nec.co.jp> <1164838985.4992.30.camel@edge>
In-Reply-To: <1164838985.4992.30.camel@edge>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

I've got some systems that I can't change the kernel on (external 
vendor) that
are 32bit but I'm running into the performance problem that is fixed by 
using
inode64. Is there any known way of working around the problem on a 32bit 
kernel?

In our case, the problem occurs as soon as you start to delete files and 
write new ones.

Cheers,

Deanan
