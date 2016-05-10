Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 731467CA6
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 03:20:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E771AAC006
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 01:20:34 -0700 (PDT)
Received: from mail.SerNet.de (mail1.SerNet.de [193.175.80.2]) by cuda.sgi.com
	with ESMTP id kYeez8SOFfhM6upS (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 01:20:31 -0700 (PDT)
Date: Tue, 10 May 2016 10:20:22 +0200
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v21 00/22] Richacls
Message-ID: <20160510082022.GC26892@sernet.de>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
	<20160510041809.GB1079@sernet.de>
	<20160510081150.GA3411@jeremy-ThinkPad-T430s>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160510081150.GA3411@jeremy-ThinkPad-T430s>
Reply-To: Volker.Lendecke@SerNet.DE
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeremy Allison <jra@samba.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, May 10, 2016 at 10:11:50AM +0200, Jeremy Allison wrote:
> +1 from me. This is something that many vendors need
> and have needed for a very long time. Getting this
> in will allow *large* amounts of existing storage to
> be migrated to Linux.

ZFS has NFSv4 richacls, and people seem to risk shitstorms
for ZFS. Not only for this of course, but they do
contribute.

Volker

-- =

SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
