Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10F4B7CA2
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 17:12:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E77BC8F8035
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 15:12:24 -0800 (PST)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com
	[209.85.213.54]) by cuda.sgi.com with ESMTP id B2Z1MZXF8YfM5JNF
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 15:12:22 -0800 (PST)
Received: by mail-vk0-f54.google.com with SMTP id k196so95628064vka.0
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 15:12:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56C0F150.60008@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F150.60008@gmail.com>
Date: Mon, 15 Feb 2016 00:12:21 +0100
Message-ID: <CAHc6FU49uRb11HhO655jimn_CzLrDyGHAB2iDAv92cftCCXkEA@mail.gmail.com>
Subject: Re: richacl(7) man page review comments
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Sun, Feb 14, 2016 at 10:27 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 02/12/2016 11:25 PM, Andreas Gruenbacher wrote:
>> We could sure move acl(5) and richacl(7) there.
>
> We already have acl(5) (now "acl(7)" in man pages) ;-).

Hmm, I can't find that page either in
git://git.kernel.org/pub/scm/docs/man-pages/man-pages or on
http://man7.org/. Are you sure you don't mean xattr.7 == attr.5 which
documents the xattr syscall interface?

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
