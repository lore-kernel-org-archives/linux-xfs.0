Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 07:48:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5REmgeh017328
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 07:48:42 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87AA2292C63
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 07:49:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ppC2yX5iiJDWDbSb for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 07:49:43 -0700 (PDT)
Message-ID: <4864FE05.9000706@sandeen.net>
Date: Fri, 27 Jun 2008 09:49:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix mount option parsing in remount
References: <20080518153539.GA5218@lst.de> <20080603080019.GB19608@lst.de> <20080627131136.GD23431@lst.de>
In-Reply-To: <20080627131136.GD23431@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> ping^2
> 
> On Tue, Jun 03, 2008 at 10:00:19AM +0200, Christoph Hellwig wrote:
>> ping?  silently ignoring wrong options causes a lot of confusion for
>> users, and the patch sould simple enough.  Anyone take 10 minutes to
>> review it and check it in?

I sorta reviewed it earlier but I'll give it my formal ACK.

-Eric
