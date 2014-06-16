Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EFEB97F3F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 09:29:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 850DAAC00F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 07:29:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id a6qw6gHpFtBtXTSZ for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 07:29:19 -0700 (PDT)
Message-ID: <539EFF41.2070302@sandeen.net>
Date: Mon, 16 Jun 2014 09:29:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsprogs: indicate default mount options in xfs.5
	manpage
References: <5398B5ED.6030703@redhat.com> <5398B649.6020600@sandeen.net>
	<20140616094020.GC26172@infradead.org>
In-Reply-To: <20140616094020.GC26172@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Karel Zak <kzak@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 6/16/14, 4:40 AM, Christoph Hellwig wrote:
> On Wed, Jun 11, 2014 at 03:04:25PM -0500, Eric Sandeen wrote:
>> Not every pair of mount options indicated which was the
>> default, so add those.
> 
> Looks good, but why have this separate from the previous patch?
> 

just to keep the move separate from any "functional" changes.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
