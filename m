Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14DDE7F37
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 21:08:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F10CAC002
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 19:08:41 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 3AJtAdNSkf0GOJWI (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Apr 2014 19:08:39 -0700 (PDT)
Date: Mon, 14 Apr 2014 22:08:36 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] generic/237: fix filtering for expected failure
	message
Message-ID: <20140415020836.GB21827@thunk.org>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
	<1397343317-14669-4-git-send-email-tytso@mit.edu>
	<20140414001408.GC27694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414001408.GC27694@dastard>
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

After looking at this more closely, this patch isn't needed.  It was a
configuration screw up on my end.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
