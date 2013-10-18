Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB4E27F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:47:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57436AC001
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:47:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OzzuiMXGw3aBjSvQ for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 15:47:47 -0700 (PDT)
Message-ID: <5261BA91.4080808@sandeen.net>
Date: Fri, 18 Oct 2013 17:47:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <20131011041911.238407600@sgi.com>
	<20131011042007.923283516@sgi.com>
	<526180B4.1030903@sandeen.net> <52618239.2090502@sandeen.net>
	<20131018224644.GY4446@dastard>
In-Reply-To: <20131018224644.GY4446@dastard>
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
Cc: rjohnston@sgi.com, xfs@oss.sgi.com

On 10/18/13 5:46 PM, Dave Chinner wrote:
> All the dump/restore tests do this. It's common code, so once you
> know it for one, it's obvious for the rest. Hence addin a comment in
> just this test would be kinda strange...

Meh, ok.  So I have to know it, eh?  ;)

Fine by me, then.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
