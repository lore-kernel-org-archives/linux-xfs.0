Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C78A97CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 14:51:57 -0500 (CDT)
From: Troy McCorkell <tdm@sgi.com>
Subject: RE: dropping IRIX support in xfsprogs
Date: Thu, 18 Aug 2016 19:51:55 +0000
Message-ID: <DF733A1EC32F124D86BC1188068FECB101A72E658E@P-EXMB4-DC21.corp.sgi.com>
References: <20160818174742.GA14464@infradead.org>
In-Reply-To: <20160818174742.GA14464@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Christoph,

No objections from SGI about removing IRIX support from xfsprogs.

Thanks,
Troy McCorkell


________________________________________
From: xfs-bounces@oss.sgi.com [xfs-bounces@oss.sgi.com] on behalf of Christoph Hellwig [hch@infradead.org]
Sent: Thursday, August 18, 2016 12:47 PM
To: xfs@oss.sgi.com
Subject: RFC: dropping IRIX support in xfsprogs

Hi all,

I'd like to know if anyone would complain about removing IRIX support
in xfsprogs?  It very much looks unmaintained for years, and due to
the IRIX differences in type defintions and kernel interfaces it's
actually a bit of a drag on xfsprogs, so unlike the other ports
to FreeBSD and Darwin it would actually be really helpful to remove
it.

I'd volunteer to prepare patches to remove the IRIX support and do
the resulting cleanups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
