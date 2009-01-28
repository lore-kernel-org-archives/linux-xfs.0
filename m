Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SKbnvI151624 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 14:37:50 -0600
Received: from nf-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7AD4C57D4
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:37:07 -0800 (PST)
Received: from nf-out-0910.google.com (nf-out-0910.google.com
	[64.233.182.186]) by cuda.sgi.com with ESMTP id
	4EQTOZvBRiDMKdZ0 for <xfs@oss.sgi.com>;
	Wed, 28 Jan 2009 12:37:07 -0800 (PST)
Received: by nf-out-0910.google.com with SMTP id h3so1270365nfh.42
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:37:06 -0800 (PST)
Date: Wed, 28 Jan 2009 21:37:03 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: invalidated gpg signatures (was: Re: xfs open questions)
Message-ID: <20090128203703.GB3958@teal.hq.k1024.org>
References: <200901270928.29215@zmi.at> <4980712A.4050500@thebarn.com>
	<49807510.20100@thebarn.com>
	<200901282122.05588.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200901282122.05588.Martin@lichtvoll.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

On Wed, Jan 28, 2009 at 09:22:00PM +0100, Martin Steigerwald wrote:
> Am Mittwoch 28 Januar 2009 schrieb Russell Cattelan:
> > Russell Cattelan wrote:
> > > Michael Monnerie wrote:
> > >> On Mittwoch 28 Januar 2009 Russell Cattelan wrote:
> > >>> The sig is there, are you saying it's broken somehow?
> > >>> It might have something to do with the html stripper.
> > >>
> > >> Yes, I use kmail (from KDE) which automatically displays mails with
> > >> gpg- sigs in different colours to easily see if it's
> > >> correct/trusted/wrong. And on this list, my messages all come with
> > >> "Invalid Sig".
> > >
> > > Well I ran a test email through the test list on oss and it seems to
> > > work fine.
> > >
> > > Let try it here then, I'm going to sign this and see if it come back
> > > to me with a valid sig.
> >
> > Grr try #2
> 
> Shown as invalid here - as the signature of Michael. I mentioned this a 
> few times already to.
> 
> Signing this as well, but I expect it will come out as invalid too.

For what is worth, gpg tells me on your email:

gpg: Signature made Wed 28 Jan 2009 09:22:00 PM CET using DSA key ID A59984C7
gpg: Good signature from "Martin Steigerwald <Martin@Lichtvoll.de>"
gpg:                 aka "Martin Steigerwald <Martin.Steigerwald@Web.de>"
gpg:                 aka "Martin Steigerwald (Helios) <Martin@Lichtvoll.de>"
gpg:                 aka "Martin Steigerwald <Martin.Steigerwald@Googlemail.com>"

So maybe it's not the mailling list itself, but something else?

regards,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
