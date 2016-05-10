Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E36857CA4
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 03:12:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5D778F8035
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 01:12:53 -0700 (PDT)
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148]) by cuda.sgi.com
	with ESMTP id 5rRwmcTCPl9EmG3f (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 01:12:51 -0700 (PDT)
Date: Tue, 10 May 2016 10:11:50 +0200
From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH v21 00/22] Richacls
Message-ID: <20160510081150.GA3411@jeremy-ThinkPad-T430s>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
	<20160510041809.GB1079@sernet.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160510041809.GB1079@sernet.de>
Reply-To: Jeremy Allison <jra@samba.org>
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
To: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, May 10, 2016 at 06:18:10AM +0200, Volker Lendecke wrote:
> On Tue, May 10, 2016 at 12:02:33AM +0200, Andreas Gruenbacher wrote:
> > What more can I do to finally get this merged?
> 
> While I am not the one to comment on kernel specifics, from a pure Samba
> user space perspective let me say: We need this. NOW.

+1 from me. This is something that many vendors need
and have needed for a very long time. Getting this
in will allow *large* amounts of existing storage to
be migrated to Linux.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
