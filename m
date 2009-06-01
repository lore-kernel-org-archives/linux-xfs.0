Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n51GjtR2022203 for <xfs@oss.sgi.com>; Mon, 1 Jun 2009 11:45:56 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EFBCD8F8050
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2009 09:46:12 -0700 (PDT)
Message-Id: <36C1B891-5BC9-4149-AF22-58BC22AD7A3A@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <PkPeJtNB3KO.A._pF.ZVbIKB@chimera>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Mon, 1 Jun 2009 11:46:12 -0500
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
	<PkPeJtNB3KO.A._pF.ZVbIKB@chimera>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alex Samad <alex@samad.com.au>, Kernel Testers List <kernel-testers@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

[cc'ing the xfs mailing list]

On May 30, 2009, at 2:55 PM, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still  
> should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13375
> Subject		: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
> Submitter	: Alex Samad <alex@samad.com.au>
> Date		: 2009-05-20 0:37 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=124278675503699&w=4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
