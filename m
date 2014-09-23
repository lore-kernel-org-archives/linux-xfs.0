Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E47D329DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:02:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70C1BAC006
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 13:02:17 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [193.170.194.197]) by
	cuda.sgi.com with ESMTP id u0MWESpKdvae4WRV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 13:02:14 -0700 (PDT)
Date: Tue, 23 Sep 2014 22:02:12 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140923200212.GA15923@two.firstfloor.org>
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com> <54216F20.1090302@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54216F20.1090302@sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, Andi Kleen <andi@firstfloor.org>, tinguely@sgi.com, xfs@oss.sgi.com


> The bulk of the table deals with Korean.

Is a table of Korean exceptions 250k too?

If not please find some other way to compress this.

I'm sure there is redundancy somewhere.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
