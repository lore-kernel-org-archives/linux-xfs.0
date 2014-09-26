Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C15687FEF
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 12:10:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0430304053
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 10:10:15 -0700 (PDT)
Date: Fri, 26 Sep 2014 10:10:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/10] xfs: add trie generator and supporting code for
	UTF-8.
Message-ID: <20140926171010.GB28044@infradead.org>
References: <20140918195650.GI19952@sgi.com> <20140918201518.GJ4482@sgi.com>
	<20140922205714.GN4267@dastard> <20140923185721.GV19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140923185721.GV19952@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Tue, Sep 23, 2014 at 01:57:21PM -0500, Ben Myers wrote:
> I'll get this moved to lib/ as you suggested elsewhere in the
> thread.

Given that this is a host side tool it should be under scripts/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
