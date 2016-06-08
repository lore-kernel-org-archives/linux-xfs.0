Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C89167CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 03:07:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A047304051
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 01:07:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tM4A2buqJoW3rZRE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 01:07:07 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 13D3CC0003FE
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 08:07:07 +0000 (UTC)
Received: from redhat.com (vpn-48-2.rdu2.redhat.com [10.10.48.2])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u58873vt013585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>; Wed, 8 Jun 2016 04:07:06 -0400
Date: Wed, 8 Jun 2016 10:07:03 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/3] xfs: add an option to enable reflinks at mount time
Message-ID: <20160608080703.GA8987@redhat.com>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<1464877150-20457-4-git-send-email-hch@lst.de>
	<20160606112342.GB23695@redhat.com>
	<20160608070459.GC18458@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160608070459.GC18458@infradead.org>
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
To: xfs@oss.sgi.com

On Wed, Jun 08, 2016 at 12:04:59AM -0700, Christoph Hellwig wrote:
> Yes, the comment is wrong.  Any reason you didn't include me in the
> reply?  Also it seems your reply-to also magically drops you
> from the reply.  Are you using a new mailer? :)

No, no reason, I missed to CC you. Maybe my CTRL-L list-reply in mutt screwed up
with the destination fields, I should come back to group replies, thanks for the
heads up :)

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
