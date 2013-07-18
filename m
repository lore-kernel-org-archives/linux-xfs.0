Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2CC567F3F
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 09:51:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 15A368F8035
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 07:51:07 -0700 (PDT)
Received: from smtprelay04.ispgateway.de (smtprelay04.ispgateway.de
	[80.67.31.31]) by cuda.sgi.com with ESMTP id Yc2ZztLTgJmLYSf4
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Jul 2013 07:51:06 -0700 (PDT)
Date: Thu, 18 Jul 2013 16:51:03 +0200
Message-ID: <20130718165103.Horde.2fnDfu2TMCHHT7990c6Vqw2@webmail.df.eu>
From: Andreas.Klauer@metamorpher.de
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs
	cleaning
References: <20130718110437.GA8090@EIS> <20130718111306.GB13468@dastard>
	<20130718112938.GB8090@EIS> <20130718124511.GC13468@dastard>
In-Reply-To: <20130718124511.GC13468@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Quoting Dave Chinner <david@fromorbit.com>:
> Have you recently upgraded from an older kernel (i.e. older than 3.9)?

Sorry, I think I missed this question.

I update about once a month to latest stable from kernel.org.

3.8.5 (April) -> 3.9.0 (May) -> 3.9.4 (June) -> 3.10.0 (July 1st) ->  
3.10.1 (July 15th)

So no "older" kernels really. In case something really goes south I  
have good backups...

I wish it was a HDD failure, then at least I'd know what to do about it. ;)

Regards
Andreas Klauer

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
