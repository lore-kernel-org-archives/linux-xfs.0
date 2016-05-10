Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF0977CA0
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 10:57:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63A37304032
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 08:57:43 -0700 (PDT)
Received: from elasmtp-curtail.atl.sa.earthlink.net
	(elasmtp-curtail.atl.sa.earthlink.net [209.86.89.64]) by
	cuda.sgi.com with ESMTP id wNJu2aZQaNQ5sOCH for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 08:57:37 -0700 (PDT)
From: "Frank Filz" <ffilzlnx@mindspring.com>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
	<20160510041809.GB1079@sernet.de>
	<20160510081150.GA3411@jeremy-ThinkPad-T430s>
In-Reply-To: <20160510081150.GA3411@jeremy-ThinkPad-T430s>
Subject: RE: [PATCH v21 00/22] Richacls
Date: Tue, 10 May 2016 08:55:19 -0700
Message-ID: <002001d1aad4$5c3bd9f0$14b38dd0$@mindspring.com>
MIME-Version: 1.0
Content-Language: en-us
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
To: 'Jeremy Allison' <jra@samba.org>, 'Volker Lendecke' <Volker.Lendecke@SerNet.DE>
Cc: "'J. Bruce Fields'" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, 'Theodore Ts'o' <tytso@mit.edu>, 'Andreas Gruenbacher' <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, 'Trond Myklebust' <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Christoph Hellwig' <hch@infradead.org>, 'Andreas Dilger' <adilger.kernel@dilger.ca>, 'Alexander Viro' <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 'Jeff Layton' <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, 'Anna Schumaker' <anna.schumaker@netapp.com>

> On Tue, May 10, 2016 at 06:18:10AM +0200, Volker Lendecke wrote:
> > On Tue, May 10, 2016 at 12:02:33AM +0200, Andreas Gruenbacher wrote:
> > > What more can I do to finally get this merged?
> >
> > While I am not the one to comment on kernel specifics, from a pure
> > Samba user space perspective let me say: We need this. NOW.
> 
> +1 from me. This is something that many vendors need
> and have needed for a very long time. Getting this in will allow *large*
> amounts of existing storage to be migrated to Linux.

+1 from me also. Once this is in Ganesha will integrate with it also.

Frank


---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
