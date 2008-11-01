Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 03:55:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA1Atdhu029019
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 03:55:40 -0700
Received: from hole.yuiop.co.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA4CDB30A15
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 03:55:39 -0700 (PDT)
Received: from hole.yuiop.co.uk (hole.yuiop.co.uk [89.145.97.62]) by cuda.sgi.com with ESMTP id 9wKcckLHsPMBlCib for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 03:55:39 -0700 (PDT)
Message-ID: <490C359F.7080504@anonymous.org.uk>
Date: Sat, 01 Nov 2008 10:55:27 +0000
From: John Robinson <john.robinson@anonymous.org.uk>
MIME-Version: 1.0
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency =
 faster I/O on md/RAID 5?
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

On 01/11/2008 08:29, Justin Piszcz wrote:
[...]
> Why is running 3 jobs con-currently that take care of two parts each 
> more than
> twice as fast than running one job for six parts?

Because you have multiple CPUs?

Cheers,

John.
