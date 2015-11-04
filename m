Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91F9B7FBB
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 20:19:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73E51304059
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 18:19:35 -0800 (PST)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
	[209.85.217.177]) by cuda.sgi.com with ESMTP id
	dDKGAgDBvfT0WzH1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:19:34 -0800 (PST)
Received: by lbbec13 with SMTP id ec13so5800349lbb.0
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:19:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6A710DA3-0B03-4371-A1EB-7AF39F684EDC@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-21-git-send-email-agruenba@redhat.com>
	<6A710DA3-0B03-4371-A1EB-7AF39F684EDC@dilger.ca>
Date: Wed, 4 Nov 2015 03:19:32 +0100
Message-ID: <CAHc6FU5hzeEc96go331s49CMHq=_PoxduGtuakcHPp441hEzSQ@mail.gmail.com>
Subject: Re: [PATCH v13 20/51] ext4: Add richacl support
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Wed, Nov 4, 2015 at 3:13 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> Patch looks reasonable.  One minor cleanup below that could be fixed when
> the patch series is refreshed, and you can add:
>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Okay, thank you.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
