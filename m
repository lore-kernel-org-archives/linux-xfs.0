Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1921B7CA4
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 23:18:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E1360304048
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 21:18:23 -0700 (PDT)
Received: from mail.SerNet.de (mail1.SerNet.de [193.175.80.2]) by cuda.sgi.com
	with ESMTP id cJAkd6ZfTzEJ0mhZ (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 21:18:20 -0700 (PDT)
Date: Tue, 10 May 2016 06:18:10 +0200
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v21 00/22] Richacls
Message-ID: <20160510041809.GB1079@sernet.de>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
Reply-To: Volker.Lendecke@SerNet.DE
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, May 10, 2016 at 12:02:33AM +0200, Andreas Gruenbacher wrote:
> What more can I do to finally get this merged?

While I am not the one to comment on kernel specifics, from a pure Samba
user space perspective let me say: We need this. NOW.

Volker

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
