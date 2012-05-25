Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PAnP8o099680 for <xfs@oss.sgi.com>; Fri, 25 May 2012 05:49:25 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	hpJ50BHLoQDTpbnb (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 03:49:24 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so518189ghb.26
	for <xfs@oss.sgi.com>; Fri, 25 May 2012 03:49:23 -0700 (PDT)
Message-ID: <4FBF63B0.6020209@gmail.com>
Date: Fri, 25 May 2012 06:49:20 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com> <4FBF62D2.20702@fastmail.fm>
In-Reply-To: <4FBF62D2.20702@fastmail.fm>
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
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On 05/25/2012 06:45 AM, Bernd Schubert wrote:
> Hello Joe,
>
> On 05/25/2012 12:37 PM, Joe Landman wrote:
>> Hi folks:
>>
>> Just ran into this (see posted output at bottom). 3.2.14 kernel, MD RAID
>> 5, xfs file system. Not sure (precisely) where the problem is, hence
>> posting to both lists.
>
> do you have anything enabled, that would make your files to have xattrs?

Not to my knowledge.  I'll go back and re-create some files and see.

> http://oss.sgi.com/archives/xfs/2011-08/msg00233.html

Hmmm


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
