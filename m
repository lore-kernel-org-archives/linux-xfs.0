Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 21:05:27 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1655HIF024224
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 21:05:21 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1537DDA07C0
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 21:05:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id WGqjiFxanKgJhG7A for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 21:05:11 -0800 (PST)
Message-ID: <47A93FE4.3000808@sandeen.net>
Date: Tue, 05 Feb 2008 23:04:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix mkfs.xfs default AG sizing
References: <op.t52twvh83jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t52twvh83jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> Based on Eric's patches and my investigations, I have generated
> the attached patch.
> 

Based on some testing of random fs sizes :), seems to resolve the problem.

Thanks,
-Eric
