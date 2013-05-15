Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0EFB07F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 10:14:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF7EDAC00A
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:14:06 -0700 (PDT)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
	[209.85.192.173]) by cuda.sgi.com with ESMTP id
	lhyGKECJPMX0TUMk (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 08:14:02 -0700 (PDT)
Received: by mail-pd0-f173.google.com with SMTP id v10so1455875pde.18
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:14:02 -0700 (PDT)
Date: Wed, 15 May 2013 23:31:46 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v5] xfstests: add a new test case for ext4 indirect-based
	file
Message-ID: <20130515153146.GA17148@gmail.com>
References: <1368463235-14478-1-git-send-email-wenqing.lz@taobao.com>
	<519394D8.2050005@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519394D8.2050005@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, May 15, 2013 at 08:59:52AM -0500, Rich Johnston wrote:
[...]
> Hey Zheng,
> 
> Thanks for submitting this patch. Looks like this patch does not
> apply cleanly.

Hi Rich,

Yes, this patch bases against Eric's patch:
  [PATCH] xfstests: automatically add -F to xfs_io on non-xfs

But his patch hasn't been applied.  So that is why this patch doesn't
apply cleanly.  Do I need to resend a cleanly version?

Thanks,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
