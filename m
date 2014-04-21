Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 336AA7F54
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 02:14:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C2F0304032
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 00:14:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id hNoA7OIW7IpipiIE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 00:14:06 -0700 (PDT)
Date: Mon, 21 Apr 2014 00:14:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] repair: remove more dirv1 leftovers
Message-ID: <20140421071404.GH20384@infradead.org>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-8-git-send-email-david@fromorbit.com>
	<20140416132332.GA4180@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416132332.GA4180@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 09:23:34AM -0400, Brian Foster wrote:
> I'm not quite familiar with how we manage the .po translation files, but
> FYI this string appears in a couple of them. Not sure whether there is
> value in keeping the translation around. The string does include the
> specific function name.

They are dead but harmless after the original ones are removed.  The
next time the translators generate the translatable strings they won't
be in there, and they should be removed with the translation update.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
