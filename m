Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11EE77F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 16:17:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E71BE8F8054
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 14:17:45 -0800 (PST)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
	[209.85.217.180]) by cuda.sgi.com with ESMTP id
	SSUv6v5C6OpKvMuO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2015 14:17:15 -0800 (PST)
Received: by lbbcs9 with SMTP id cs9so10217937lbb.1
	for <xfs@oss.sgi.com>; Thu, 03 Dec 2015 14:17:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449090088-9281-1-git-send-email-agruenba@redhat.com>
References: <1449090088-9281-1-git-send-email-agruenba@redhat.com>
Date: Thu, 3 Dec 2015 23:17:13 +0100
Message-ID: <CAHc6FU6U3TXfacHWNeY=ihw_EwEVRWU-hAmR7rYNN+duqfa_Ww@mail.gmail.com>
Subject: Re: [PATCH v16 00/22] Richacls (Core and Ext4)
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>

On Wed, Dec 2, 2015 at 10:01 PM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> The complete patch queue is available in git form here:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
>         richacl-2015-11-09

This should have been richacl-2015-12-02, sorry.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
