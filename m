Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67AC77FAD
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 09:20:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C168304090
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 07:20:12 -0700 (PDT)
Received: from mx5-phx2.redhat.com (mx5-phx2.redhat.com [209.132.183.37]) by
	cuda.sgi.com with ESMTP id EQRCUEFO6pU5fRiv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 07:20:03 -0700 (PDT)
Date: Tue, 4 Aug 2015 10:19:40 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <773923690.2696215.1438697980321.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150804111812.GD18906@infradead.org>
References: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
	<1438680314-23950-1-git-send-email-jtulak@redhat.com>
	<20150804111812.GD18906@infradead.org>
Subject: Re: [PATCH v4 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> 
> Needs to be fixed to avoid > 80 char lines.
> 

I don't see any >80 char line in this patch. O_o
The longest line is 73 in the code and 62 in commit 
message. Though... maybe it can be a tab width issue? 
I use four spaces for a tab...

Cheers,
Jan


-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
