Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D97A87FB1
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 18:00:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA131304053
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 16:00:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4JqhArK5iuHIH6cp for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 16:00:13 -0700 (PDT)
Date: Wed, 5 Aug 2015 09:00:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
Message-ID: <20150804230000.GW16638@dastard>
References: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
	<1438680314-23950-1-git-send-email-jtulak@redhat.com>
	<20150804111812.GD18906@infradead.org>
	<773923690.2696215.1438697980321.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <773923690.2696215.1438697980321.JavaMail.zimbra@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 04, 2015 at 10:19:40AM -0400, Jan Tulak wrote:
> ----- Original Message -----
> > From: "Christoph Hellwig" <hch@infradead.org>
> > 
> > Needs to be fixed to avoid > 80 char lines.
> > 
> 
> I don't see any >80 char line in this patch. O_o
> The longest line is 73 in the code and 62 in commit 
> message. Though... maybe it can be a tab width issue? 
> I use four spaces for a tab...

8 spaces to a tab, please. Same coding style rules as for writing
kernel code. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
