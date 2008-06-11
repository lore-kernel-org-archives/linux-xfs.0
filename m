Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 19:37:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5B2bqX3013882
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 19:37:53 -0700
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EB92C71EF7
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 19:38:48 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by cuda.sgi.com with ESMTP id ihnpGwtIc2SZhG8E for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 19:38:48 -0700 (PDT)
Message-ID: <484F3CDF.10001@sauce.co.nz>
Date: Wed, 11 Jun 2008 14:47:59 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com>
In-Reply-To: <484F2CD7.9070506@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Hi Timothy,

Timothy Shimmin wrote:

> Ah, the 32 bit inode versus 64 bit inode question :)
> I don't have any definitive answers and I'm sure there will be people
> on the list with their opinions and experiences.
> So just some thoughts...

On balance, I'm thinking the best compromise might be to stay 32 bit and 
bump the inode size to 2048 bytes.

Regards,

Richard
