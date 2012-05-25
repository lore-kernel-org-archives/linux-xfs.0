Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PGsk1t142478 for <xfs@oss.sgi.com>; Fri, 25 May 2012 11:54:46 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 3Yb8FM7QHfBBGZ64
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 May 2012 09:54:45 -0700 (PDT)
Received: by yhp26 with SMTP id 26so922870yhp.26
	for <xfs@oss.sgi.com>; Fri, 25 May 2012 09:54:44 -0700 (PDT)
Message-ID: <4FBFB953.6050505@gmail.com>
Date: Fri, 25 May 2012 12:54:43 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com> <20120525165719.GV16099@sgi.com>
In-Reply-To: <20120525165719.GV16099@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On 05/25/2012 12:57 PM, Ben Myers wrote:
> Hey Joe,

[...]

> There are a couple recent fixes related to discard that are probably
> appropriate for 3.2-stable.


[...]

> I'm not saying that they'll fix your problem, but you should consider giving
> them a whirl.

Ok, will do a respin over the weekend and try from there.  Thanks!

Joe

>
> Regards,
> Ben
>

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
