Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 726827F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 04:27:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CAEBAC004
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 02:27:36 -0800 (PST)
Received: from mail-ee0-f42.google.com (mail-ee0-f42.google.com
	[74.125.83.42]) by cuda.sgi.com with ESMTP id 9m5snNeEOIjiUIPx
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 02:27:29 -0800 (PST)
Received: by mail-ee0-f42.google.com with SMTP id d17so1294857eek.1
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 02:27:28 -0800 (PST)
Date: Thu, 27 Feb 2014 11:27:05 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: [PATCH] util-linux/fallocate: introduce an option -c to support
	FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20140227102704.GB29013@gmail.com>
References: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
	<1393355305-12009-1-git-send-email-dongsu.park@profitbricks.com>
	<20140225193101.GW13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225193101.GW13647@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

Hi Dave,

On 26.02.2014 06:31, Dave Chinner wrote:
> FYI, we've already got support in xfs_io for collapse-range tests
> inside xfstests.
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=commit;h=ca692f162d36c871c9c1b6169136b2c70503f2d8
> There are already several tests that use it.

Thanks for the info!

Dongsu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
