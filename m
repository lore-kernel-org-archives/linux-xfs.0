Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC3E77F7C
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 10:34:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9688304066
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 08:34:50 -0700 (PDT)
Received: from mail-yk0-f181.google.com (mail-yk0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	0ozuVCfQYIEXaptD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 08:34:46 -0700 (PDT)
Received: by ykay144 with SMTP id y144so44199620yka.3
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 08:34:45 -0700 (PDT)
Date: Thu, 13 Aug 2015 11:34:42 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: generic/04[89] fail on XFS due to change in writeback code
	[4.2-rc1 regression]
Message-ID: <20150813153442.GE4496@mtj.duckdns.org>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150813004435.GN3902@dastard>
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
Cc: axboe@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

On Thu, Aug 13, 2015 at 10:44:35AM +1000, Dave Chinner wrote:
> It might be a couple of days before I really get a chance to dig
> into this, so it might be best if Tejun can look into it first.

Yeap, have been looking into it since yesterday.  I have some
suspicions.  I'll write once I know more.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
