Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Nov 2006 19:37:37 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAA3bVaG015452
	for <xfs@oss.sgi.com>; Thu, 9 Nov 2006 19:37:31 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0A214E24B1
	for <xfs@oss.sgi.com>; Thu,  9 Nov 2006 19:36:39 -0800 (PST)
Message-ID: <4553F3C6.2030807@sandeen.net>
Date: Thu, 09 Nov 2006 21:36:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem performance drop in kernels 2.6.16+
References: <bde600590611090930g3ab97aq3c76d7bca4ec267f@mail.gmail.com>
In-Reply-To: <bde600590611090930g3ab97aq3c76d7bca4ec267f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Igor A. Valcov" <viaprog@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Igor A. Valcov wrote:

> I also noticed that I/O barriers were introduced in v2.6.16 and
> thought they may be the cause, but mounting the file system with
> 'nobarrier' doesn't seem to affect the performance in any way.


did this happen to be a remount with nobarrier, or a fresh mount?

-Eric
