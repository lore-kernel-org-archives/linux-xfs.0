Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Mar 2008 08:20:04 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m23GJgDL013174
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2008 08:19:43 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E6DBF084D5
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2008 08:20:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id GucNplOQSdaDSxCU for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 08:20:08 -0800 (PST)
Message-ID: <47CC2536.7080205@sandeen.net>
Date: Mon, 03 Mar 2008 10:20:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: disappearing xfs partition
References: <e03b90ae0803030514v585249ecjf93af325287b59f@mail.gmail.com> <alpine.DEB.1.00.0803030857590.29466@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.00.0803030857590.29466@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Breidenbach <jeff@jab.org>, xfs@oss.sgi.com

Justin Piszcz wrote:
> Looks like a udev problem or something is not making /dev/sde1? Have you 
> tried a manual mknod of the device?

but... it is not an xfs problem.  :)

(also check /proc/partitions for sde1...)

-Eric
