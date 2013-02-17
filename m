Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 371288001
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 15:04:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 085D3304043
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 13:04:11 -0800 (PST)
Received: from mail-interne2.pasteur.fr (mail-interne2.pasteur.fr
	[157.99.64.81]) by cuda.sgi.com with ESMTP id 1U6g3MJFaPYDb5Yp
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 13:04:09 -0800 (PST)
Date: Sun, 17 Feb 2013 22:04:08 +0100
From: Tru Huynh <tru@pasteur.fr>
Subject: Re: High %user CPU in XFS
Message-ID: <20130217210408.GH2513@sillage.bis.pasteur.fr>
References: <CAEUQcehy1fy5-W-TA--2emBgL3y9JskqRPCZf1ED5JDbPHqKTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEUQcehy1fy5-W-TA--2emBgL3y9JskqRPCZf1ED5JDbPHqKTQ@mail.gmail.com>
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
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 17, 2013 at 09:20:46PM +0530, Subranshu Patel wrote:
>  I created 2 filesystem on my system (RHEL 6.3, kernel 2.6.32) - XFS
> and EXT4 and mounted them.
probably:
https://bugzilla.redhat.com/show_bug.cgi?id=883905

Tru
-- 
Dr Tru Huynh          | http://www.pasteur.fr/recherche/unites/Binfs/
mailto:tru@pasteur.fr | tel/fax +33 1 45 68 87 37/19
Institut Pasteur, 25-28 rue du Docteur Roux, 75724 Paris CEDEX 15 France  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
