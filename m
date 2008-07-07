Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 18:13:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m671DHaY007140
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 18:13:18 -0700
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22A4611DC4BB
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 18:14:21 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by cuda.sgi.com with ESMTP id V5z1fv5VKvJt0dVK for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 18:14:21 -0700 (PDT)
Message-ID: <48716FEE.7070806@sauce.co.nz>
Date: Mon, 07 Jul 2008 13:22:54 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: XFS Recovery
References: <48715CEF.8010008@sauce.co.nz> <20080707000745.GI29319@disturbed>
In-Reply-To: <20080707000745.GI29319@disturbed>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:

>>XFS mounting filesystem md5
>>Starting XFS recovery on filesystem: md5 (logdev: /dev/md0)
>>Ending XFS recovery on filesystem: md5 (logdev: /dev/md0)
> 
> 
> That's normal output when mounting an XFS filesystem - if
> you see more than this then there might be problems...

Thanks Dave,

I was more used to seeing:

XFS mounting filesystem md5
Ending clean XFS mount for filesystem: md5

Maybe the message has changed with later kernels.

In any case, it sounds like I have no issues.

Regards,

Richard
